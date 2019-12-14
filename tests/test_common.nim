import unittest
import ../src/refaqtory/common as comm

suite "common starter":
    echo "common suite"

    setup:
        echo "setup"

    teardown:
        echo "teardown"

    test "seeme test":
        comm.setDisplay()
        see(message="seeme")