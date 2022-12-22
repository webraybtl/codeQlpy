import java
import semmle.code.java.J2EE


/**
 * Holds if `m` is a test method indicated by:
 *    a) in a test directory such as `src/test/java`
 *    b) in a test package whose name has the word `test`
 *    c) in a test class whose name has the word `test`
 *    d) in a test class implementing a test framework such as JUnit or TestNG
 */
predicate isTestMethod(Method m) {
  m.getDeclaringType().getName().toLowerCase().matches("%test%") or // Simple check to exclude test classes to reduce FPs
  m.getDeclaringType().getPackage().getName().toLowerCase().matches("%test%") or // Simple check to exclude classes in test packages to reduce FPs
  exists(m.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java")) or //  Match test directory structure of build tools like maven
  m instanceof TestMethod // Test method of a test case implementing a test framework such as JUnit or TestNG
}



/** The `main` method in an Enterprise Java Bean. */
class EnterpriseBeanMainMethod extends Method {
  EnterpriseBeanMainMethod() {
    this.getDeclaringType() instanceof EnterpriseBean and
    this instanceof MainMethod and
    not isTestMethod(this)
  }
}

from EnterpriseBeanMainMethod sm
select sm, "Java EE application has a main method."
