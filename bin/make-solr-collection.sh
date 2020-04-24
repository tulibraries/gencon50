#/usr/bin/env bash
GENCON50_TAG="1.0"

# create-release-configs
@echo "Grabbing  gencon50 config latest release versions"
echo "Gencon50 Solr Configs Version: $GENCON50_TAG"
wget "https://github.com/tulibraries/gencon50-solr/releases/download/$GENCON50_TAG/gencon50-$GENCON50_TAG.zip" -O data/tmp/collections/gencon50-$GENCON50_TAG.zip
curl -X POST --header "Content-Type:application/octet-stream" --data-binary @data/tmp/collections/gencon50-$GENCON50_TAG.zip "http://localhost:8090/solr/admin/configs?action=UPLOAD&name=gencon50-$GENCON50_TAG"

# create-release-collections:
curl "http://localhost:8090/solr/admin/collections?action=CREATE&name=gencon50-$GENCON50_TAG&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=gencon50-$GENCON50_TAG"

# create-aliases
@echo "Creating or Updating gencon50 Stage (Dev) & Prod aliases"
curl "http://localhost:8090/solr/admin/collections?action=CREATEALIAS&name=gencon50-$GENCON50_TAG-qa&collections=gencon50-$GENCON50_TAG"
curl "http://localhost:8090/solr/admin/collections?action=CREATEALIAS&name=gencon50-$GENCON50_TAG-dev&collections=gencon50-$GENCON50_TAG"
curl "http://localhost:8090/solr/admin/collections?action=CREATEALIAS&name=gencon50-$GENCON50_TAG-prod&collections=gencon50-$GENCON50_TAG"
