proc find_clock {cell } {
    # To get all clock domaines of object
    set clocks [get_clocks -of_objects $cell ] 
    if {[llength $clocks ] > 1} {
        return "Cloks are more than one"
    }
    return [lindex $clocks 0] 
}

proc ldelete { list value } {
    set ix [lsearch -exact $list $value]
    if {$ix >= 0} {
        return [lreplace $list $ix $ix]
    } else {
        return $list
    }
}


proc debug { cell ila_name } {

    save_constraints
    
    # Get the pins of the selected objects
    set pins [get_pins -of_objects $cell ]  
    
    # Create a debug core instance named u_ila_0 of type ila
    create_debug_core $ila_name ila 
    connect_debug_port ${ila_name}/clk [get_nets -hierarchical [find_clock $cell ] ]
    
    #Remove clock signal
    set pin_without_clock $pins

    puts "Number of pins: [llength $pin_without_clock]"

    foreach pin $pins { 
        set is_clk [get_nets -of_objects $pin -filter "TYPE == GLOBAL_CLOCK"] 
        if {[llength $is_clk] != 0} { 
            set pin_without_clock [ldelete $pin_without_clock $pin] 
        } else {
            continue
        }
    }

    
    # Check deleted signal
    puts "Number of pins after deleting: [llength $pin_without_clock]"
    puts "Pins without clocks: $pin_without_clock"
    
    # Initialize variables
    set width 1
    set probe_num 0
    
    # Iterate over each pin
    for {set i 0} {$i < [expr [llength $pins]]} {incr i $width } {
        
        # Get the current pin
        set pin [lindex $pins $i ]
        
        # Check if the pin is connected
        if {[get_property IS_CONNECTED $pin ] == 1} {
            # Get the net associated with the pin
            set net [get_nets -of_objects $pin ]
            
            # Check if the net is not a bus (i.e., has a bus width property)
            if {[get_property BUS_WIDTH $net ] eq ""} { # if not a bus
                puts "width of $net = 1"
                set width 1
            } else { # if bus then find a bus width
                # bus
                set width [get_property BUS_WIDTH $net ]
                puts "width of $net = $width"
            }
            
            # Create a new debug port if this is not the first pin
            if  {$i > 0} { create_debug_port $ila_name probe }
            
            # Set the width of the debug port
            set_property port_width $width [get_debug_ports ${ila_name}/probe${probe_num}]
            
            puts "probe${probe_num} width = $width"
            
            # Connect each bit of the bus (or the single bit net) to the debug port
            for {set j 0} {$j < $width } {incr j} {
                # get current pin 
                set pin [lindex $pins [expr $i + $j ]] 
                # get net of pin
                set net [get_nets -of_objects $pin ]
                connect_debug_port ${ila_name}/probe${probe_num} [get_nets $net]
                puts "connected to probe$probe_num -> $net"
            }
            
            # Increment the probe number for the next iteration
            incr probe_num 
        }
    }
}