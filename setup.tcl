set PROJECT_DIR  [lindex $argv 0]
set PROJECT_NAME [lindex $argv 1]

set SOURCE_PATHS [glob -nocomplain -- ./rtl/*.sv]
set INCLUDE_PATHS [glob -nocomplain -- ./inc/*.mem]
set TB_PATHS [glob -nocomplain -- ./tb/*.sv]
set IP_PATHS [glob -nocomplain -- ./ip/*.xci]
set CONSTR_PATHS [glob -nocomplain -- ./constraints/*.xdc]

puts "Using project directory: $PROJECT_DIR"
create_project -force -dir $PROJECT_DIR -name $PROJECT_NAME -part xc7a35tcpg236-1

set_property -name "board_part" -value "digilentinc.com:basys3:part0:1.1" -objects [current_project]

read_ip $IP_PATHS
update_ip_catalog

foreach ip [get_ips *] {
     generate_target all [get_files $ip.xci]
}

add_files -norecurse -fileset sources_1 $SOURCE_PATHS
add_files -norecurse -fileset sources_1 $INCLUDE_PATHS

add_files -norecurse -fileset sim_1 $TB_PATHS

set_property top led_matrix_demo_top [get_filesets sources_1]
set_property top tb_led_matrix_controller [get_filesets sim_1]

update_compile_order -fileset sources_1

add_files -fileset constrs_1 $CONSTR_PATHS
