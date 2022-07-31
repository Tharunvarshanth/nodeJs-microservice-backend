include common.mk

# This is default to development.
# During deployment "include deploy.aws.mk" should be uncomment and "include deploy.local.mk" should be commented.
include deploy.local.mk
#include deploy.aws.mk
include dev.mk
