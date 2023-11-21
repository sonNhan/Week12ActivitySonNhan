/**
 * @description Find public methods that are called by tests.
 * @kind problem
 * @id javascript/public-methods-called-by-tests
 * @problem.severity recommendation
 */
import javascript

/**
 * Holds a method is public
 */
predicate isPublicMethod(Function method) {
    exists(MethodDefinition md | md.isPublic() && md.getBody() = method)
}

/**
* Holds if the given function is exported from a module.
*/
predicate isExportedFunction(Function f) {
    exists(Module m | m.getAnExportedValue(_).getAFunctionValue().getFunction() =f) and not f.inExternsFile()
}

predicate isTest(Function test) {
  exists(CallExpr describe, CallExpr it |
    describe.getCalleeName() = "describe" and
    it.getCalleeName() = "it" and
    it.getParent*() = describe and
    test = it.getArgument(1)
  )
}

from Function test, Function callee
where isPublicMethod(test) and isExportedFunction(test) and isTest(test) and calls(test, callee)
select callee + " is a public method called by a test"