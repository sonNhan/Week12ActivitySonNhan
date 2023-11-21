/**
 * @description Find public methods that are called by tests
 * @kind problem
 * @id javascript/public-method-called-by-test
 * @problem.severity recommendation
 */
import javascript

/**
* Holds if the given function is a public method of a class.
*/
predicate isPublicMethod(Function f) {
    exists(MethodDefinition md | md.isPublic() and md.getBody() = f)
}

/**
* Holds if the given function is exported from a module.
*/
predicate isExportedFunction(Function f) {
    exists(Module m | m.getAnExportedValue(_).getAFunctionValue().getFunction() =f) andnot f.inExternsFile()
}

/**
 * Holds if a function is a test.
 */
predicate isTest(Function test) {
  exists(CallExpr describe, CallExpr it |
    describe.getCalleeName() = "describe" and
    it.getCalleeName() = "it" and
    it.getParent*() = describe and
    test = it.getArgument(1)
  )
}

/**
* Holds if `caller` contains a call to `callee`.
*/
predicate calls(Function caller, Function callee) {
  exists(DataFlow::CallNode call |
    call.getEnclosingFunction() = caller and
    call.getACallee() = callee
  )
}

from Function test, Function callee
where isTest(test) and isPublicMethod(callee) and isExportedFunction(callee)
      calls(test, callee)
select callee, "is a public method directly called by a test"