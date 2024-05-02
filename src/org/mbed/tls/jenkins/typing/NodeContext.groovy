package org.mbed.tls.jenkins.typing;

/**
 * Dummy class used to indicate that a method calls its Callable parameter inside a
 * node context by annotating the parameter with {@link groovy.lang.DelegatesTo DelegatesTo(NodeContext)}
 * @see groovy.lang.DelegatesTo
 */
class NodeContext {}
