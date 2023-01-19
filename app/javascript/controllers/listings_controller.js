import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static targets = ["form"]
  static debounces = ["refresh"]

  connect() {
    useDebounce(this, { wait: 100 })
  }

  refresh() {
    this.formTarget.requestSubmit()
  }
}
