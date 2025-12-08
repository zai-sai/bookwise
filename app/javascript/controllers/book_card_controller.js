import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book-card"
export default class extends Controller {
  static targets = ["description"];

  connect() {
    // console.log("Connected to BookCardController");
    if (this.descriptionTarget.scrollHeight > this.descriptionTarget.clientHeight) {
      // console.log(`true - ${this.descriptionTarget.innerText}`);
    }
  }

  maxLength(element) {
    console.log("true");
    // Binary search
    const text = element.innerText;
    let low = 0;
    let high = element.innerText.length;
    let tmp = "";

    while (low < high) {
      let mid = Math.floor((high + low) / 2);
      tmp = tmp.slice(0, mid);
      if (tmp.scrollHeight > element.clientHeight) {
      }
    }
  }

}
