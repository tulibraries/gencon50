const Blacklight = (() => {
  const buffer = []

  return {
    onLoad(func) {
      buffer.push(func)
    },

    activate() {
      buffer.forEach((func) => func.call())
    },

    listeners() {
      if (typeof Turbo !== "undefined") {
        return ["turbo:load"]
      }

      if (typeof Turbolinks !== "undefined" && Turbolinks.supported) {
        return Turbolinks.BrowserAdapter ? ["turbolinks:load"] : ["page:load", "DOMContentLoaded"]
      }

      return ["DOMContentLoaded"]
    }
  }
})()

Blacklight.listeners().forEach((listener) => {
  document.addEventListener(listener, () => Blacklight.activate())
})

Blacklight.onLoad(() => {
  const elem = document.querySelector(".no-js")
  if (!elem) return

  elem.classList.remove("no-js")
  elem.classList.add("js")
})

Blacklight.doResizeFacetLabelsAndCounts = function() {
  function longer(a, b) {
    return b.textContent.length - a.textContent.length
  }

  document.querySelectorAll(".facet-values, .pivot-facet").forEach((elem) => {
    const nodes = elem.querySelectorAll(".facet-count")
    const longest = Array.from(nodes).sort(longer)[0]

    if (longest?.textContent) {
      elem.querySelector(".facet-count").style.width = `${longest.textContent.length + 1}ch`
    }
  })
}

Blacklight.onLoad(() => {
  Blacklight.doResizeFacetLabelsAndCounts()
})

Blacklight.onLoad(() => {
  document.querySelectorAll("button.collapse-toggle").forEach((button) => {
    button.addEventListener("click", (event) => {
      event.currentTarget.focus()
    })
  })
})

Blacklight.doSearchContextBehavior = function() {
  document.querySelectorAll("a[data-context-href]").forEach((element) => {
    element.addEventListener("click", (event) => {
      Blacklight.handleSearchContextMethod.call(event.currentTarget, event)
    })
  })
}

Blacklight.csrfToken = () => document.querySelector('meta[name="csrf-token"]')?.content
Blacklight.csrfParam = () => document.querySelector('meta[name="csrf-param"]')?.content

Blacklight.handleSearchContextMethod = function(event) {
  const link = this
  let target = link.getAttribute("target")
  const href = link.getAttribute("data-context-href")
  const csrfToken = Blacklight.csrfToken()
  const csrfParam = Blacklight.csrfParam()
  const form = document.createElement("form")

  form.method = "post"
  form.action = href

  let formContent = `<input name="_method" value="post" type="hidden" />
    <input name="redirect" value="${link.getAttribute("href")}" type="hidden" />`

  if (event.metaKey || event.ctrlKey) {
    target = "_blank"
  }

  if (csrfParam !== undefined && csrfToken !== undefined) {
    formContent += `<input name="${csrfParam}" value="${csrfToken}" type="hidden" />`
  }

  formContent += '<input type="submit" />'

  if (target) form.setAttribute("target", target)

  form.style.display = "none"
  form.innerHTML = formContent
  document.body.appendChild(form)
  form.querySelector('[type="submit"]').click()

  event.preventDefault()
  event.stopPropagation()
}

Blacklight.onLoad(() => {
  Blacklight.doSearchContextBehavior()
})

Blacklight.modal = {
  modalSelector: "#blacklight-modal",
  triggerLinkSelector: 'a[data-blacklight-modal~="trigger"]',
  triggerFormSelector: 'form[data-blacklight-modal~="trigger"]',
  preserveLinkSelector: '#blacklight-modal a[data-blacklight-modal~="preserve"]',
  preserveFormSelector: '#blacklight-modal form[data-blacklight-modal~="preserve"]',
  containerSelector: '[data-blacklight-modal~="container"]',
  modalCloseSelector: '[data-blacklight-modal~="close"]'
}

Blacklight.modal.element = () => document.querySelector(Blacklight.modal.modalSelector)

Blacklight.modal.show = function(element = Blacklight.modal.element()) {
  if (!element) return

  if (typeof bootstrap !== "undefined" && bootstrap.Modal) {
    bootstrap.Modal.getOrCreateInstance(element).show()
  }
}

Blacklight.modal.hide = function(element = Blacklight.modal.element()) {
  if (!element) return

  if (typeof bootstrap !== "undefined" && bootstrap.Modal) {
    bootstrap.Modal.getOrCreateInstance(element).hide()
  }
}

Blacklight.modal.checkCloseModal = function(modalElement) {
  if (!modalElement.querySelector(Blacklight.modal.modalCloseSelector)) return false

  const modalFlashes = modalElement.querySelector(".flash_messages")
  const mainFlashes = document.querySelector("#main-flashes")

  Blacklight.modal.hide(modalElement)

  if (modalFlashes && mainFlashes) {
    mainFlashes.append(modalFlashes)
    modalFlashes.style.display = ""
  }

  return true
}

Blacklight.modal.receiveResponse = async function(response) {
  const modalElement = Blacklight.modal.element()
  if (!modalElement) return

  const modalContent = modalElement.querySelector(".modal-content")
  const contents = await response.text()
  const wrapper = document.createElement("div")

  wrapper.innerHTML = contents

  const container = wrapper.querySelector(Blacklight.modal.containerSelector)
  modalContent.innerHTML = container ? container.innerHTML : contents

  const loadedEvent = new CustomEvent("loaded.blacklight.blacklight-modal", {
    bubbles: true,
    cancelable: true
  })

  modalElement.dispatchEvent(loadedEvent)
  if (loadedEvent.defaultPrevented) return
  if (Blacklight.modal.checkCloseModal(modalElement)) return

  Blacklight.modal.show(modalElement)
}

Blacklight.modal.onFailure = async function(response) {
  const modalElement = Blacklight.modal.element()
  if (!modalElement) return

  const modalContent = modalElement.querySelector(".modal-content")
  const message = response
    ? `${response.status} ${response.statusText}`.trim()
    : "Network error"

  modalContent.innerHTML = `<div class="modal-header">
      <div class="modal-title">There was a problem with your request.</div>
      <button type="button" class="blacklight-modal-close btn-close close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
    <div class="modal-body">
      <p>Expected a successful response from the server, but got an error.</p>
      <pre>${message}</pre>
    </div>`

  Blacklight.modal.show(modalElement)
}

Blacklight.modal.request = async function(url, options = {}) {
  const headers = {
    Accept: "text/html, application/xhtml+xml"
  }

  if (options.method && options.method.toUpperCase() !== "GET") {
    const csrfToken = Blacklight.csrfToken()
    if (csrfToken) headers["X-CSRF-Token"] = csrfToken
  }

  const response = await fetch(url, {
    credentials: "same-origin",
    headers,
    ...options
  })

  if (!response.ok) {
    Blacklight.modal.onFailure(response)
    return
  }

  await Blacklight.modal.receiveResponse(response)
}

Blacklight.modal.modalAjaxLinkClick = async function(event) {
  event.preventDefault()

  try {
    await Blacklight.modal.request(this.href)
  } catch {
    Blacklight.modal.onFailure()
  }
}

Blacklight.modal.modalAjaxFormSubmit = async function(event) {
  event.preventDefault()

  try {
    await Blacklight.modal.request(this.action, {
      body: new FormData(this),
      method: this.method || "post"
    })
  } catch {
    Blacklight.modal.onFailure()
  }
}

Blacklight.modal.setupModal = function() {
  document.body.addEventListener("click", (event) => {
    const link = event.target.closest(
      `${Blacklight.modal.triggerLinkSelector}, ${Blacklight.modal.preserveLinkSelector}`
    )
    if (!link) return

    Blacklight.modal.modalAjaxLinkClick.call(link, event)
  })

  document.body.addEventListener("submit", (event) => {
    const form = event.target.closest(
      `${Blacklight.modal.triggerFormSelector}, ${Blacklight.modal.preserveFormSelector}`
    )
    if (!form) return

    Blacklight.modal.modalAjaxFormSubmit.call(form, event)
  })

  document.body.addEventListener("click", (event) => {
    const closeLink = event.target.closest(`${Blacklight.modal.modalSelector} a[data-dismiss~="modal"]`)
    if (closeLink) event.preventDefault()
  })
}

Blacklight.onLoad(() => {
  if (Blacklight.modal._setup) return

  Blacklight.modal.setupModal()
  Blacklight.modal._setup = true
})

window.Blacklight = Blacklight
