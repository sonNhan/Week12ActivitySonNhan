/**
 * @description Find functions that are over 10 lines of code
 * @kind problem
 * @id javascript/functions-over-ten-loc
 * @problem.severity recommendation
 */
import javascript

/**
 * Holds if a function is a test.
 */
predicate isOverTenLOC(Function func) {
    func.getNumLines() > 10
}

from Function function
where isOverTenLOC(function)
select function, " is over 10 lines of code"