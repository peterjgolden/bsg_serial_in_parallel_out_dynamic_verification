import random
from collections import deque

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


async def reset_dut(dut, cycles=5):
    dut.reset_i.value = 1
    dut.v_i.value = 0
    dut.len_i.value = 0
    dut.data_i.value = 0
    dut.yumi_i.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk_i)
    dut.reset_i.value = 0
    await RisingEdge(dut.clk_i)


async def send_packet(dut, words):
    pkt_len_field = len(words) - 1

    for idx, word in enumerate(words):
        accepted = False
        while not accepted:
            dut.v_i.value = 1
            dut.data_i.value = word
            dut.len_i.value = pkt_len_field if idx == 0 else dut.len_i.value
            await RisingEdge(dut.clk_i)
            accepted = int(dut.ready_and_o.value) == 1

    dut.v_i.value = 0


async def output_driver(dut, expected_packets):
    while True:
        dut.yumi_i.value = random.randint(0, 1)
        await RisingEdge(dut.clk_i)

        if int(dut.v_o.value) and int(dut.yumi_i.value):
            assert expected_packets, "DUT produced output with no expected packet queued"
            expected = expected_packets.popleft()
            observed = [int(dut.data_o.value[i]) for i in range(len(expected))]
            assert observed == expected, f"packet mismatch: observed={observed} expected={expected}"


@cocotb.test()
async def smoke_test(dut):
    random.seed(2026)
    cocotb.start_soon(Clock(dut.clk_i, 10, units="ns").start())
    await reset_dut(dut)

    expected_packets = deque()
    cocotb.start_soon(output_driver(dut, expected_packets))

    for _ in range(10):
        length = random.randint(1, len(dut.data_o))
        words = [random.randint(0, (1 << len(dut.data_i)) - 1) for _ in range(length)]
        expected_packets.append(words)
        await send_packet(dut, words)

    for _ in range(40):
        await RisingEdge(dut.clk_i)

    assert not expected_packets, f"packets left undrained: {len(expected_packets)}"
