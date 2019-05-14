from __future__ import division
from radish import steps, before
from nose.tools import assert_true, assert_equals


@before.each_scenario
def demo_hook_before(scenario):
    print('This text from hook should appear before background')


@steps
class MathSteps(object):

    def demo_message_is_displayed(self, step):
        """demo message is displayed"""
        print('This message is being displayed as part of background')

    def expression_is_valid(self, step, expression):
        """expression {expression:QuotedString} is valid"""
        assert_true(all([not x.isalpha() for x in list(str(expression))]))
        print('Expression {} is valid'.format(expression))

    def expression_is_evaluated(self, step, expression):
        """expression {expression:QuotedString} is evaluated"""
        step.context.expression_evaluated = eval(expression)
        print('Evaluated {} is {}'.format(expression, step.context.expression_evaluated))

    def result_is_equal_to(self, step, expected_result):
        """result is equal to {expected_result:QuotedString}"""
        assert_equals(str(step.context.expression_evaluated), str(expected_result))
        print('Values {} {} match'.format(step.context.expression_evaluated, expected_result))
