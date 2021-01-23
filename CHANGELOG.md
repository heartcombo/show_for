## Unreleased

* Respect `nil` value when provided, by skipping model attribute value.
* Add support for Rails 6.1, drop support for Rails < 5.2.
* Move CI to GitHub Actions.

## 0.7.0

* Add support for Rails 6.0.
* Drop support for Rails < 5.0 and Ruby < 2.4.

## 0.6.1

* Add support for Rails 5.2.
*  Fix issue causing blank class not being applied to field wrapper when the result of a Proc is empty.

## 0.6.0

* Relaxed dependencies to support Rails 5.1.

## 0.5.0

* Relaxed dependencies to support Rails 5.
* Removed support for Rails `3.2` and `4.0` and Ruby `1.9.3` and `2.0.0`.

### enhancements
  * Do not generate label/content/wrapper/collection classes when config is set to `nil`.

## 0.4.0

### enhancements
  * Change default `wrapper_tag` to generate a `div` instead of `p`. The `p` tag generates
    invalid HTML with collections: `p > ul`, and failed tests on Rails 4.2. If you depend
    on the `p` tag being generated, change your Show For config to set `wrapper_tag` to `:p`.
  * Remove deprecated `:method` in favor of `:using`.
  * Improve support to Rails 4.x associations with more duck typing instead of Array checks.
  * Support Rails 4.1/4.2 and Ruby 2.1/2.2.
  * Add `skip_blanks` configuration option to skip generating blank attributes
    instead of generating them with a default message. (by github.com/moktin)
  * Add `slim` template for the install generator. (by github.com/voanhduy1512)
  * Add `separator` option that overrides the global configuration (by github.com/bernardofire)

### bugfix
  * Do not yield default blank value to the block when using an empty association. (by github.com/aptinio)

## 0.3.0

### bug fix
  * Fix blank value not being applied when using a block. (by github.com/tfwright)

## 0.3.0.rc

### enhancements
  * Support Rails 4.
  * Drop support to Rails < 3.2 and Ruby 1.8.

## 0.2.6

### enhancements
  * Ruby 2.0 support.
  * Add Haml template. (by github.com/nashby) Closes #12.
  * Add `blank_html` tanslation. (by github.com/nashby)
  * Add `show_for_class` configuration option. (by github.com/nashby)

### bug fix
  * Make show_for works with namespaced models. (by github.com/fabiokr)
  * Add `blank_content_class` to the attributes. (by github.com/blakehilscher). Closes #24.
  * Don't call `association.map` if association method is nil (by github.com/nashby). Closes #40.

## 0.2.5

### enhancements
  * Add a `:value` option for attribute (by github.com/ml-gt)
  * Add `label_class`, `content_class`, `wrapper_class` and `collection_class` configuration options (by github.com/wojtekmach)

### bug fix
  * Fix problem with `label => false` and `html_safe` (label => false) (by github.com/nashby)

## 0.2.4

### enhancements
  * Do not add separator if label is not present (by github.com/eugenebolshakov)
  * Add method for output value only (by github.com/jenkek)

### bug fix
  * Fix empty labels to be `html_safe` (label => false) (by github.com/eugenebolshakov)

## 0.2.3

### enhancements
  * added :attributes method to generate all attributes given
  * update generator to use the new syntax show_for:install

### bug fix
  * fix numeric types

## 0.2.2

### bug fix
  * allow show_for to work with AR association proxies

### enhancements
  * improvements on html safe and output buffers

## 0.2.1

### enhancements
  * added label_proc
  * compatibility with latest Rails

## 0.2.0

### enhancements
  * Rails 3 compatibility

## 0.1.4

### bug fix
  * allow show_for to work with AR association proxies

## 0.1.3

### enhancements
  * allow builder to be given to show_for

### bug fix
  * Fix typo in yaml

## 0.1.2

### enhancements
  * allow `f.attribute :nickname, in: :profile` as association shortcut

### deprecations
  * `:method` now becomes `:using`

## 0.1.1

### enhancements
  * HAML compatibility (by github.com/grimen)
  * blank_content support (by github.com/grimen)

## 0.1

### First release
