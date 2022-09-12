WOKWI_PROJECT_ID=342563183205024338

HARDEN_ENV=docker

generate:
	ir_converter_main --top=user_module src/user_module.x > src/user_module.ir
	opt_main src/user_module.ir > src/user_module_opt.ir
	codegen_main --module_name user_module_USER_MODULE_ID --use_system_verilog=false --generator=combinational src/user_module_opt.ir > src/user_module.v

fetch:
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' src/user_module.v > src/user_module_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/scan_wrapper.v > src/scan_wrapper_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/config.tcl > src/config.tcl
	echo $(WOKWI_PROJECT_ID) > src/ID

harden: harden_$(HARDEN_ENV)

# needs PDK_ROOT and OPENLANE_ROOT, OPENLANE_IMAGE_NAME set from your environment
harden_docker:
	docker run --rm \
	-v $(OPENLANE_ROOT):/openlane \
	-v $(PDK_ROOT):$(PDK_ROOT) \
	-v $(CURDIR):/work \
	-e PDK_ROOT=$(PDK_ROOT) \
	-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
	$(OPENLANE_IMAGE_NAME) \
	/bin/bash -c "./flow.tcl -overwrite -design /work/src -run_path /work/runs -tag wokwi"

harden_native:
	$(OPENLANE_ROOT)/flow.tcl -override_env $(OPENLANE_OVERRIDE_ENV) -design src/ -run_path runs/ -ignore_mismatches
