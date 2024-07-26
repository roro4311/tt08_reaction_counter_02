import cocotb
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge

@cocotb.coroutine
async def test_reaction_timer(dut):
    """Test the reaction timer with 7-segment displays."""

    # Initialize the inputs
    dut.ui_in.value = 0
    dut.rst_n.value = 0
    dut.ena.value = 0

    # Release reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Press the button
    await RisingEdge(dut.clk)
    dut.ui_in[0].value = 1

    # Wait a few clock cycles
    for _ in range(10):
        await RisingEdge(dut.clk)

    # Release the button
    dut.ui_in[0].value = 0

    # Wait a few more clock cycles to allow reaction time to be registered
    await RisingEdge(dut.clk)
    for _ in range(10):
        await RisingEdge(dut.clk)

    # Check the LED status
    led_status = dut.uo_out[0].value
    assert led_status == 1, f"LED should be on, but it is {led_status}"

    # Get the reaction time from uio_out using bitwise operations
    uio_out = int(dut.uio_out.value)
    seg0 = uio_out & 0xFF
    seg1 = (uio_out >> 8) & 0xFF
    seg2 = (uio_out >> 16) & 0xFF
    seg3 = (uio_out >> 24) & 0xFF

    reaction_time = (seg3 << 24) | (seg2 << 16) | (seg1 << 8) | seg0
    assert reaction_time != 0, "Reaction time should be updated"

    # Print the reaction time and 7-segment display values
    print(f"Reaction time: {reaction_time}")
    print(f"7-segment displays: {seg3:02X} {seg2:02X} {seg1:02X} {seg0:02X}")

# Create a TestFactory and generate tests
tf = TestFactory(test_reaction_timer)
tf.generate_tests()

