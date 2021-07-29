REGION ?= us-east-1
PROFILE ?= test
ENV_NAME ?= dev
KEY_PAIR_ID ?= KXCR0NHKGF42N
PRIVATE_KEY_FILE ?= cloudfront_private_key.pem
TEST_URL ?= https://d3kprv3ebh74lt.cloudfront.net/blades_rules_2.png
TEST_DATE ?= 2021-08-03

.PHONY: create-stack
create-stack:
	@aws cloudformation create-stack \
  --profile $(PROFILE) \
  --stack-name cloudfront-mixed-poc-$(ENV_NAME) \
  --region $(REGION) \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://poc.cfn.yml

.PHONY: delete-stack
delete-stack:
	@aws cloudformation delete-stack \
  --profile $(PROFILE) \
  --stack-name cloudfront-mixed-poc-$(ENV_NAME) \
  --region $(REGION)

.PHONY: update-stack
update-stack:
	@aws cloudformation update-stack \
  --profile $(PROFILE) \
  --stack-name cloudfront-mixed-poc-$(ENV_NAME) \
  --region $(REGION) \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://poc.cfn.yml

.PHONY: sign-test
sign-test:
	echo $(KEY_PAIR_ID)
	aws cloudfront sign \
	--profile $(PROFILE) \
	--key-pair-id $(KEY_PAIR_ID) \
	--private-key file://$(PRIVATE_KEY_FILE) \
	--date-less-than $(TEST_DATE) \
	--url $(TEST_URL)
