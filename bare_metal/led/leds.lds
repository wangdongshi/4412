SECTIONS {
	. = 0x02023400;
	.text ALIGN(4): {
		start.o(.text);
		*(.text);
	}

	.rodata ALIGN(4): {
		*(.rodata);
	}

	.data ALIGN(4) : {
		*(.data);
	}

	__initcall_start__ = .;
	.initcall ALIGN(4) : {
		*(.initcall);
	}
	__initcall_end__ = .;

	__bss_start__ = .;
	.bss ALIGN(4) : {
		*(.bss);
	}
	__bss_end__ = .;
}
