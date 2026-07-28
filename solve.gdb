set sysroot /
set disable-randomization on
file ./loader

# python function
python
import re

def pie_calc_address(binja_address):
    exe_base = 0
    binja_base = 0
    offset = binja_address - binja_base
    exe_address = exe_base + offset
    return hex(exe_address)

def pie_break(binja_address):
    exe_address = pie_calc_address(binja_address)
    gdb.execute(f"break *{exe_address}")

def pie_print(binja_address, message):
    exe_address = pie_calc_address(binja_address)

    SIZES = {'hh': 'char', 'h': 'short', 'l': 'long', 'll': 'long', '': 'int'}

    pattern = r'\{(\*?)([^,}]+),\s*%(hh|h|ll|l)?(\w)\}'
    fmt = re.sub(pattern, r'%\4', message)

    args = []
    for star, expr, size, kind in re.findall(pattern, message):
        expr = expr.strip()
        if kind == 's':
            args.append(f"*(char**)({expr})" if star else f"(char*)({expr})")
        else:
            ctype = f"unsigned {SIZES[size]}"
            args.append(f"*({ctype}*)({expr})" if star else expr)

    gdb_args = ", ".join(args)
    suffix = f', {gdb_args}' if gdb_args else ''
    gdb.execute(f'dprintf *{exe_address}, "{fmt}\\n"{suffix}')

def pie_watch(binja_address):
    exe_address = pie_calc_address(binja_address)
    gdb.execute(f"watch *{exe_address}")

end
# gdb script
# b main
python pie_break(0x8049286)
run "$(cat quine.bin)"
