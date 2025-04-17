`define assert(sig, val) \
    if (sig !== val) begin \
        $display("ASSERTION FAILED in %m: Expected %b, got %b", val, sig); \
        $finish; \
    end