# Release notes

## 0.1.0

No changes from 0.0.20, just time for a minor version release.

## 0.0.20

 * Added a `#thread_context` attribute to the `SimpleFormatter` that is `false`
   by default, but when set to `true` will output the context of the thread
   within messages in the same style as the `StandardFormatter`

## 0.0.19

 * Changed core formatters to output an indented backtrace after a message when
   an error is present, can be disabled via the formatter's `backtrace=`
   attribute

## 0.0.18

 * Made the presence of a `formatter=` method on appenders optional

## 0.0.17

 * Added the ability to pass an error along with your message

### Bug fixes

 * Fixed the fallback logging if an appender raises an error whilst trying to
   log a message
 * Ensured all logging calls truly do return `nil` rather than it just being
   part of the documented contract