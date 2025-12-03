import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shelf-cards"
export default class extends Controller {
  static targets = ["moreShelves", "toggleLink"];

  toggleShelves() {
    this.moreShelvesTarget.classList.toggle("d-none");
    if (this.toggleLinkTarget.innerText === "Show all shelves...") {
      this.toggleLinkTarget.innerText = "Show less shelves...";
    } else {
      this.toggleLinkTarget.innerText = "Show all shelves...";
    }
  }
}
