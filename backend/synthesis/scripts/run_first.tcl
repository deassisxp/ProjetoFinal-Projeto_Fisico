

export DESIGNS="multiplier32FP" ;# put here the name of current design
export USER=??????????? ;# put here YOUR user name at this machine
export PROJECT_DIR=/home/${USER}/projetos/${DESIGNS}
export BACKEND_DIR=${PROJECT_DIR}/backend
export TECH_DIR=/home/tools/design_kits/cadence/GPDK045 ;# technology dependent
export HDL_NAME=${DESIGNS}
#
module add cdn/genus/genus211 		;# GENUS
module add cdn/xcelium/xcelium2209 	;# XCELIUM
module add cdn/innovus/innovus211 	;# INNOVUS
module add cdn/ic/ic231 		;# VIRTUOSO
module add cdn/assura/assura41 		;# ASSURA


# Para executar o XCELIUM
#cd ${PROJECT_DIR}/frontend
#xrun -64bit -v200x -v93 ${TECH_DIR}/gsclib045_all_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v Componentes.vhd full_add.vhd adder.vhd adder23.vhd adder48.vhd multiplier.vhd data_path.vhd control_path.vhd  multiplier32FP.vhd sim/UtilPackage.vhd sim/multiplier32FP_tb.vhd -top multiplier32FP_tb -access +rwc -gui

# Para executar o GENUS
#cd ${PROJECT_DIR}/backend/synthesis/work
# apenas o programa
#genus -abort_on_error -lic_startup Genus_Synthesis -lic_startup_options Genus_Physical_Opt -log genus -overwrite
# programa e carrega script para síntese automatizada
#genus -abort_on_error -lic_startup Genus_Synthesis -lic_startup_options Genus_Physical_Opt -log genus -overwrite -files ${PROJECT_DIR}/backend/synthesis/scripts/${DESIGNS}.tcl



