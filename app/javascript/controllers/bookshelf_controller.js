import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["book", "titleView", "titleForm"]

  // Called when user clicks "Edit this bookshelf"
  enterEdit() {
     // Start wobble on all book covers
    this.bookTargets.forEach((el) => {
      el.classList.add("editing")
    })

    // Swap title text for inline edit form
    if (this.hasTitleViewTarget) {
      this.titleViewTarget.classList.add("d-none")
    }
    if (this.hasTitleFormTarget) {
      this.titleFormTarget.classList.remove("d-none")
    }
  }
}
