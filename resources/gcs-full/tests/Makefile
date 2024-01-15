with-gcs:
	score-humanitec delta \
		--app ${APP} \
		--env ${ENVIRONMENT} \
		--org ${HUMANITEC_ORG} \
		--token ${HUMANITEC_TOKEN} \
		--deploy \
		--retry \
		-f score-with-gcs.yaml

without-gcs:
	score-humanitec delta \
		--app ${APP} \
		--env ${ENVIRONMENT} \
		--org ${HUMANITEC_ORG} \
		--token ${HUMANITEC_TOKEN} \
		--deploy \
		--retry \
		-f score-without-gcs.yaml