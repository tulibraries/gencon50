import "./popper.umd.js"

const Popper = globalThis.Popper

const top = "top"
const bottom = "bottom"
const right = "right"
const left = "left"
const auto = "auto"
const basePlacements = [top, bottom, right, left]
const start = "start"
const end = "end"
const clippingParents = "clippingParents"
const viewport = "viewport"
const popper = "popper"
const reference = "reference"
const baseModifierPhases = [
  "beforeRead",
  "read",
  "afterRead",
  "beforeMain",
  "main",
  "afterMain",
  "beforeWrite",
  "write",
  "afterWrite",
]
const variationPlacements = basePlacements.flatMap((placement) => [
  `${placement}-${start}`,
  `${placement}-${end}`,
])
const placements = [auto, ...basePlacements, ...variationPlacements]

const createPopperBase = Popper.popperGenerator({
  defaultModifiers: [
    Popper.eventListeners,
    Popper.popperOffsets,
    Popper.computeStyles,
    Popper.applyStyles,
  ],
})

export {
  auto,
  basePlacements,
  bottom,
  clippingParents,
  createPopperBase,
  end,
  left,
  placements,
  popper,
  reference,
  right,
  start,
  top,
  variationPlacements,
  viewport,
}

export const modifierPhases = baseModifierPhases
export const beforeRead = baseModifierPhases[0]
export const read = baseModifierPhases[1]
export const afterRead = baseModifierPhases[2]
export const beforeMain = baseModifierPhases[3]
export const main = baseModifierPhases[4]
export const afterMain = baseModifierPhases[5]
export const beforeWrite = baseModifierPhases[6]
export const write = baseModifierPhases[7]
export const afterWrite = baseModifierPhases[8]

export const {
  applyStyles,
  arrow,
  computeStyles,
  createPopper,
  createPopperLite,
  defaultModifiers,
  detectOverflow,
  eventListeners,
  flip,
  hide,
  offset,
  popperGenerator,
  popperOffsets,
  preventOverflow,
} = Popper
