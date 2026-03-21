// top.sv
// UVM verifikacija modula register
// Modifikacija 4 - Prakticni deo ispita
//
// Kompajliranje i pokretanje (Questa Sim):
//   vlib work
//   vmap work work
//   vlog -coveropt 3 +cover +acc register.v top.sv
//   vsim -coverage -vopt work.top -c -do "coverage save -onexit -directive -codeAll reg_cov.ucdb; run -all"
//   vcover report -html reg_cov.ucdb

`include "uvm_macros.svh"
import uvm_pkg::*;

// ============================================================
// INTERFACE
// ============================================================
interface reg_if #(parameter DATA_WIDTH = 16) (input bit clk);
    logic                    rst_n;
    logic                    cl;
    logic                    ld;
    logic [DATA_WIDTH-1:0]   in;
    logic                    inc;
    logic                    dec;
    logic                    sr;
    logic                    ir;
    logic                    sl;
    logic                    il;
    logic [DATA_WIDTH-1:0]   out;
endinterface

// ============================================================
// SEQUENCE ITEM
// ============================================================
class reg_item #(parameter DATA_WIDTH = 16) extends uvm_sequence_item;

    // Randomizovani ulazi
    rand bit                  cl;
    rand bit                  ld;
    rand bit [DATA_WIDTH-1:0] in;
    rand bit                  inc;
    rand bit                  dec;
    rand bit                  sr;
    rand bit                  ir;   // information right (za shift right)
    rand bit                  sl;
    rand bit                  il;   // information left (za shift left)

    // Izlaz (hvata monitor)
    bit [DATA_WIDTH-1:0] out;

    `uvm_object_param_utils_begin(reg_item #(DATA_WIDTH))
        `uvm_field_int(cl,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(ld,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(in,  UVM_DEFAULT | UVM_HEX)
        `uvm_field_int(inc, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(dec, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(sr,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(ir,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(sl,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(il,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(out, UVM_NOPRINT)
    `uvm_object_utils_end

    // Ogranicenja: osiguravamo da se svaka operacija desi dovoljno cesto
    // i da se pokriju sve grane (cl, ld, inc, dec, sr, sl, i slucaj bez operacije)
    constraint c_op_distribution {
        // Svaka operacija ima priblizno jednaku sansu
        // cl, ld, inc, dec, sr, sl su medjusobno nezavisni
        // ali zbog prioriteta, koristimo distribuciju
        cl  dist {1'b1 := 10, 1'b0 := 90};
        ld  dist {1'b1 := 20, 1'b0 := 80};
        inc dist {1'b1 := 20, 1'b0 := 80};
        dec dist {1'b1 := 20, 1'b0 := 80};
        sr  dist {1'b1 := 20, 1'b0 := 80};
        sl  dist {1'b1 := 20, 1'b0 := 80};
    }

    function new(string name = "reg_item");
        super.new(name);
    endfunction

    // Pomocna funkcija za ispis
    virtual function string my_print();
        return $sformatf(
            "cl=%0b ld=%0b in=0x%0h inc=%0b dec=%0b sr=%0b ir=%0b sl=%0b il=%0b | out=0x%0h",
            cl, ld, in, inc, dec, sr, ir, sl, il, out
        );
    endfunction

endclass

// ============================================================
// SEQUENCE - glavni generator
// ============================================================
class reg_sequence #(parameter DATA_WIDTH = 16) extends uvm_sequence #(reg_item #(DATA_WIDTH));

    `uvm_object_param_utils(reg_sequence #(DATA_WIDTH))

    int num = 200;  // broj stimulusa

    function new(string name = "reg_sequence");
        super.new(name);
    endfunction

    virtual task body();
        // 1. Pokrij sve operacije eksplicitno
        // -- CLEAR
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_cl");
            start_item(item);
            item.randomize() with { cl == 1'b1; };
            `uvm_info("Sequence", "Directed: CLEAR", UVM_LOW)
            finish_item(item);
        end
        // -- LOAD
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_ld");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b1; };
            `uvm_info("Sequence", "Directed: LOAD", UVM_LOW)
            finish_item(item);
        end
        // -- INCREMENT
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_inc");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b1; };
            `uvm_info("Sequence", "Directed: INCREMENT", UVM_LOW)
            finish_item(item);
        end
        // -- DECREMENT
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_dec");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b0; dec == 1'b1; };
            `uvm_info("Sequence", "Directed: DECREMENT", UVM_LOW)
            finish_item(item);
        end
        // -- SHIFT RIGHT (ir=0)
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_sr0");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b0; dec == 1'b0; sr == 1'b1; ir == 1'b0; };
            `uvm_info("Sequence", "Directed: SHIFT RIGHT (ir=0)", UVM_LOW)
            finish_item(item);
        end
        // -- SHIFT RIGHT (ir=1)
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_sr1");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b0; dec == 1'b0; sr == 1'b1; ir == 1'b1; };
            `uvm_info("Sequence", "Directed: SHIFT RIGHT (ir=1)", UVM_LOW)
            finish_item(item);
        end
        // -- SHIFT LEFT (il=0)
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_sl0");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b0; dec == 1'b0; sr == 1'b0; sl == 1'b1; il == 1'b0; };
            `uvm_info("Sequence", "Directed: SHIFT LEFT (il=0)", UVM_LOW)
            finish_item(item);
        end
        // -- SHIFT LEFT (il=1)
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_sl1");
            start_item(item);
            item.randomize() with { cl == 1'b0; ld == 1'b0; inc == 1'b0; dec == 1'b0; sr == 1'b0; sl == 1'b1; il == 1'b1; };
            `uvm_info("Sequence", "Directed: SHIFT LEFT (il=1)", UVM_LOW)
            finish_item(item);
        end
        // -- Bez operacije (hold)
        begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item_hold");
            start_item(item);
            item.randomize() with { cl == 0; ld == 0; inc == 0; dec == 0; sr == 0; sl == 0; };
            `uvm_info("Sequence", "Directed: HOLD (no operation)", UVM_LOW)
            finish_item(item);
        end

        // 2. Pseudoslucajni stimulusi
        for (int i = 0; i < num; i++) begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("item");
            start_item(item);
            item.randomize();
            `uvm_info("Sequence", $sformatf("Random item %0d/%0d: %s", i+1, num, item.my_print()), UVM_HIGH)
            finish_item(item);
        end
    endtask

endclass

// ============================================================
// DRIVER
// ============================================================
class reg_driver #(parameter DATA_WIDTH = 16) extends uvm_driver #(reg_item #(DATA_WIDTH));

    `uvm_component_param_utils(reg_driver #(DATA_WIDTH))

    virtual reg_if #(DATA_WIDTH) vif;

    function new(string name = "reg_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual reg_if #(DATA_WIDTH))::get(this, "", "reg_vif", vif))
            `uvm_fatal("Driver", "Nije pronadjen interfejs u config_db!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        // Inicijalni idle
        vif.cl  <= 0; vif.ld  <= 0; vif.in  <= 0;
        vif.inc <= 0; vif.dec <= 0;
        vif.sr  <= 0; vif.ir  <= 0;
        vif.sl  <= 0; vif.il  <= 0;

        forever begin
            reg_item #(DATA_WIDTH) item;
            seq_item_port.get_next_item(item);

            // Primeni stimulus na posedge clk
            @(posedge vif.clk);
            vif.cl  <= item.cl;
            vif.ld  <= item.ld;
            vif.in  <= item.in;
            vif.inc <= item.inc;
            vif.dec <= item.dec;
            vif.sr  <= item.sr;
            vif.ir  <= item.ir;
            vif.sl  <= item.sl;
            vif.il  <= item.il;

            `uvm_info("Driver", $sformatf("%s", item.my_print()), UVM_MEDIUM)

            // Sacekaj jedan takt da se registar azurira
            @(posedge vif.clk);

            seq_item_port.item_done();
        end
    endtask

endclass

// ============================================================
// MONITOR
// ============================================================
class reg_monitor #(parameter DATA_WIDTH = 16) extends uvm_monitor;

    `uvm_component_param_utils(reg_monitor #(DATA_WIDTH))

    virtual reg_if #(DATA_WIDTH) vif;
    uvm_analysis_port #(reg_item #(DATA_WIDTH)) mon_ap;

    function new(string name = "reg_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual reg_if #(DATA_WIDTH))::get(this, "", "reg_vif", vif))
            `uvm_fatal("Monitor", "Nije pronadjen interfejs u config_db!")
        mon_ap = new("mon_ap", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        // Sacekaj prvu posedge posle reseta
        @(posedge vif.clk);

        forever begin
            reg_item #(DATA_WIDTH) item = reg_item #(DATA_WIDTH)::type_id::create("mon_item");

            // Hvata ulaze i izlaz POSLE jednog takta (kada je izlaz azuriran)
            @(posedge vif.clk);
            item.cl  = vif.cl;
            item.ld  = vif.ld;
            item.in  = vif.in;
            item.inc = vif.inc;
            item.dec = vif.dec;
            item.sr  = vif.sr;
            item.ir  = vif.ir;
            item.sl  = vif.sl;
            item.il  = vif.il;
            item.out = vif.out;

            `uvm_info("Monitor", $sformatf("%s", item.my_print()), UVM_MEDIUM)
            mon_ap.write(item);
        end
    endtask

endclass

// ============================================================
// SCOREBOARD
// ============================================================
class reg_scoreboard #(parameter DATA_WIDTH = 16) extends uvm_scoreboard;

    `uvm_component_param_utils(reg_scoreboard #(DATA_WIDTH))

    uvm_analysis_imp #(reg_item #(DATA_WIDTH), reg_scoreboard #(DATA_WIDTH)) mon_imp;

    // Interni model registra (prati ocekivano stanje)
    bit [DATA_WIDTH-1:0] expected_out = {DATA_WIDTH{1'b0}};

    int pass_cnt = 0;
    int fail_cnt = 0;

    function new(string name = "reg_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_imp = new("mon_imp", this);
    endfunction

    // Referentni model - isti prioritet operacija kao u register.v
    virtual function write(reg_item #(DATA_WIDTH) item);
        bit [DATA_WIDTH-1:0] expected;

        // Primeni isti prioritet kao u DUT-u:
        // CLEAR > LOAD > INC > DEC > SHIFT_RIGHT > SHIFT_LEFT > HOLD
        if (item.cl)
            expected = {DATA_WIDTH{1'b0}};
        else if (item.ld)
            expected = item.in;
        else if (item.inc)
            expected = expected_out + 1'b1;
        else if (item.dec)
            expected = expected_out - 1'b1;
        else if (item.sr)
            expected = {item.ir, expected_out[DATA_WIDTH-1:1]};
        else if (item.sl)
            expected = {expected_out[DATA_WIDTH-2:0], item.il};
        else
            expected = expected_out;  // hold

        // Provjera
        if (expected == item.out) begin
            `uvm_info("Scoreboard", $sformatf("PASS! expected=0x%0h, got=0x%0h | %s",
                expected, item.out, item.my_print()), UVM_LOW)
            pass_cnt++;
        end else begin
            `uvm_error("Scoreboard", $sformatf("FAIL! expected=0x%0h, got=0x%0h | %s",
                expected, item.out, item.my_print()))
            fail_cnt++;
        end

        // Azuriraj ocekivano stanje za sledeci ciklus
        expected_out = expected;
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("Scoreboard", $sformatf(
            "\n===========================\n  Rezultati verifikacije:\n  PASS: %0d\n  FAIL: %0d\n===========================",
            pass_cnt, fail_cnt), UVM_NONE)
    endfunction

endclass

// ============================================================
// AGENT
// ============================================================
class reg_agent #(parameter DATA_WIDTH = 16) extends uvm_agent;

    `uvm_component_param_utils(reg_agent #(DATA_WIDTH))

    reg_driver  #(DATA_WIDTH) drv;
    reg_monitor #(DATA_WIDTH) mon;
    uvm_sequencer #(reg_item #(DATA_WIDTH)) seqr;

    function new(string name = "reg_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv  = reg_driver  #(DATA_WIDTH)::type_id::create("drv",  this);
        mon  = reg_monitor #(DATA_WIDTH)::type_id::create("mon",  this);
        seqr = uvm_sequencer #(reg_item #(DATA_WIDTH))::type_id::create("seqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass

// ============================================================
// ENVIRONMENT
// ============================================================
class reg_env #(parameter DATA_WIDTH = 16) extends uvm_env;

    `uvm_component_param_utils(reg_env #(DATA_WIDTH))

    reg_agent      #(DATA_WIDTH) agt;
    reg_scoreboard #(DATA_WIDTH) sb;

    function new(string name = "reg_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = reg_agent      #(DATA_WIDTH)::type_id::create("agt", this);
        sb  = reg_scoreboard #(DATA_WIDTH)::type_id::create("sb",  this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.mon_ap.connect(sb.mon_imp);
    endfunction

endclass

// ============================================================
// TEST
// ============================================================
class reg_test #(parameter DATA_WIDTH = 16) extends uvm_test;

    `uvm_component_param_utils(reg_test #(DATA_WIDTH))

    reg_env      #(DATA_WIDTH) env;
    reg_sequence #(DATA_WIDTH) seq;

    virtual reg_if #(DATA_WIDTH) vif;

    function new(string name = "reg_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual reg_if #(DATA_WIDTH))::get(this, "", "reg_vif", vif))
            `uvm_fatal("Test", "Nije pronadjen interfejs u config_db!")
        env = reg_env      #(DATA_WIDTH)::type_id::create("env", this);
        seq = reg_sequence #(DATA_WIDTH)::type_id::create("seq");
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        // Reset
        vif.rst_n <= 1'b0;
        vif.cl  <= 0; vif.ld <= 0; vif.in <= 0;
        vif.inc <= 0; vif.dec <= 0;
        vif.sr  <= 0; vif.ir <= 0;
        vif.sl  <= 0; vif.il <= 0;
        repeat(3) @(posedge vif.clk);

        vif.rst_n <= 1'b1;
        @(posedge vif.clk);

        // Pokreni sekvencu
        seq.start(env.agt.seqr);

        // Malo sacekaj na kraju
        repeat(5) @(posedge vif.clk);

        phase.drop_objection(this);
    endtask

endclass

// ============================================================
// TOP - TESTBENCH MODULE
// ============================================================
module top;

    localparam DATA_WIDTH = 16;

    // Generisanje takta
    bit clk;
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // perioda = 20ns
    end

    // Instanciranje interfejsa
    reg_if #(DATA_WIDTH) dut_if (.clk(clk));

    // Instanciranje DUT-a (register.v mora biti kompajliran zajedno)
    register #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk   (clk),
        .rst_n (dut_if.rst_n),
        .cl    (dut_if.cl),
        .ld    (dut_if.ld),
        .in    (dut_if.in),
        .inc   (dut_if.inc),
        .dec   (dut_if.dec),
        .sr    (dut_if.sr),
        .ir    (dut_if.ir),
        .sl    (dut_if.sl),
        .il    (dut_if.il),
        .out   (dut_if.out)
    );

    // Pokretanje UVM testa
    initial begin
        // Postavi interfejs u config_db da ga driver/monitor mogu dohvatiti
        uvm_config_db #(virtual reg_if #(DATA_WIDTH))::set(null, "*", "reg_vif", dut_if);
        run_test("reg_test #(16)");
    end

endmodule
