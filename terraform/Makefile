TARGETS = plan apply fix clean destroy

.PHONY: apply fix clean destroy

.terraform/:
	terraform init

plan: .terraform/
	terraform plan -out plan

apply: .terraform/ plan
	terraform apply plan

fix: .terraform/ terraform.tfstate
	terraform apply

destroy: .terraform/
	terraform destroy

clean:
	rm -f plan
