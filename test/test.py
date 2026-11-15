import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_counter(dut):
    # Set initial input values
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Start the clock
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the chip
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Let it run for 50 cycles to verify it doesn't crash
    await ClockCycles(dut.clk, 50)