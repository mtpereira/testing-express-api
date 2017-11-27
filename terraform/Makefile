TARGETS = init plan apply clean destroy

.PHONY: $(TARGETS)

init: .terraform/
	terraform init

plan: init 
	terraform plan -out plan

apply: init plan
	terraform apply plan

destroy: init
	terraform destroy

clean:
	rm -f plan
