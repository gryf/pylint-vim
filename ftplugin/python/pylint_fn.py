"""
Get pylint oputput on current buffer
"""
import sys
import re
from StringIO import StringIO

try:
    from pylint import lint
    from pylint.reporters.text import TextReporter
except ImportError:
    pylint = None

import vim


class VImPylint(object):
    """Vim pylint interface"""

    sys_stderr = sys.stderr
    dummy_stderr = StringIO()
    conf_msg = 'No config file found, using default configuration\n'

    @classmethod
    def run(self):
        """execute pylint and fill the quickfix"""

        if not pylint:
            vim.command("echo 'Error: pylint_fm.vim requires module pylint'")
            return

        # clear QF window
        vim.command('call setqflist([])')

        # args
        args = ['-rn',  # display only the messages instead of full report
                vim.current.buffer.name]

        buf = StringIO()  # file-like buffer, instead of stdout
        reporter = TextReporter(buf)

        sys.stderr = self.dummy_stderr
        lint.Run(args, reporter=reporter, exit=False)
        sys.stderr = self.sys_stderr

        self.dummy_stderr.seek(0)
        error_list = self.dummy_stderr.readlines()
        self.dummy_stderr.truncate(0)
        if error_list and self.conf_msg in error_list:
            error_list.remove(self.conf_msg)
            if error_list:
                raise Exception(''.join(error_list))

        buf.seek(0)

        bufnr = vim.current.buffer.number
        error_list = []

        error_re = re.compile(r'^(?P<type>[C,R,W,E,F]):\s+?'
                              r'(?P<lnum>[0-9]+),\s+?'
                              r'(?P<col>[0-9]+):\s'
                              r'(?P<text>.*)$')
        for line in buf:
            line = line.rstrip()  # remove trailing newline character

            error_line = error_re.match(line)
            if error_line:
                error_line = error_line.groupdict()
                error_line["bufnr"] = bufnr

                error_list.append(error_line)

        vim.command('call setqflist(%s)' % str(error_list))
        if error_list:
            vim.command('copen')
