import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book-card"
export default class extends Controller {
  static targets = ["description"];

  maxLength() {
    // Binary search
    const text = this.descriptionTarget.innerText;
    let low = 0;
    let high = this.descriptionTarget.innerText.length;
    let fit = 0;
    while (low <= high) {
      let mid = Math.floor((high + low) / 2);
      this.descriptionTarget.innerText = text.slice(0, mid);
      if (this.descriptionTarget.scrollHeight <= this.descriptionTarget.clientHeight) {
        // => It fits => Upper half
        fit = mid
        low = mid + 1
      } else {
        // => It doesn't fit => Lower half
        high = mid - 1
      }
    }
    if (fit < text.length) {
      // => There's more text
      fit -= 3;
      this.descriptionTarget.innerText = text.slice(0, fit) + "..."
    } else {
      // => This is the entirety of the text
      this.descriptionTarget.innerText = text.slice(0, fit)
    }
  }

  checkOverflow() {
    this.descriptionTarget.innerText = this.fullText;
    if (this.descriptionTarget.scrollHeight > this.descriptionTarget.clientHeight) {
      // => It doesn't fit
      this.maxLength();
    }
  }

  getBreakPoint() {
    if (window.innerWidth < 576) {
      return "xs";
    } else if (window.innerWidth < 768) {
      return "sm";
    } else if (window.innerWidth < 992) {
      return "md";
    } else if (window.innerWidth < 1200) {
      return "lg";
    } else if (window.innerWidth < 1400) {
      return "xl";
    } else {
      return "xxl";
    }
  }

  checkBreakPoint() {
    // (Optional) Call based on Boostrap breakpoints
    if (this.getBreakPoint !== this.currentBreakPoint) {
      this.currentBreakPoint = this.getBreakPoint;
      this.checkOverflow()
    }
  }

  connect() {
    // console.log("Connected to BookCardController");

    this.fullText = this.descriptionTarget.innerText;
    // this.currentBreakPoint = this.getBreakPoint();

    this.checkOverflow();
    this._resizeListener = () => this.checkOverflow();
    window.addEventListener("resize", this._resizeListener);
  }

  disconnect() {
    window.removeEventListener("resize", this._resizeListener);
  }
}
