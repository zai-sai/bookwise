import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-books-index"
export default class extends Controller {
  static targets = ["allBooks", "readBooks", "unreadBooks", "book"];

  connect() {
    this.showAllBooks();
  }

  showReadBooks() {
    this.bookTargets.forEach((book) => {
      const status = book.dataset.status;
      if (status === "unread") {
        book.classList.add("d-none");
      } else {
        book.classList.remove("d-none");
      }
    });
  }

  showUnreadBooks() {
    this.bookTargets.forEach((book) => {
      const status = book.dataset.status;
      if (status === "read") {
        book.classList.add("d-none");
      } else {
        book.classList.remove("d-none");
      }
    });
  }

  showAllBooks() {
    this.allBooksTarget.classList.add("active");
    this.allBooksTarget.setAttribute("aria-pressed", "true");

    this.readBooksTarget.classList.remove("active");
    this.readBooksTarget.setAttribute("aria-pressed", "false");

    this.unreadBooksTarget.classList.remove("active");
    this.unreadBooksTarget.setAttribute("aria-pressed", "false");

    this.bookTargets.forEach((book) => {
      book.classList.remove("d-none");
    });
  }

  toggleReadBooks() {
    if (this.allBooksTarget.classList.contains("active")) {
      // => All Books -> Read Books
      this.allBooksTarget.classList.remove("active");
      this.allBooksTarget.setAttribute("aria-pressed", "false");

      this.readBooksTarget.classList.add("active");
      this.readBooksTarget.setAttribute("aria-pressed", "true");

      this.showReadBooks();
    } else if (this.unreadBooksTarget.classList.contains("active")) {
      // => Unread Books -> Read Books
      this.unreadBooksTarget.classList.remove("active");
      this.unreadBooksTarget.setAttribute("aria-pressed", "false");

      this.readBooksTarget.classList.add("active");
      this.readBooksTarget.setAttribute("aria-pressed", "true");

      this.showReadBooks();
    } else {
      // => Read Books -> All Books
      this.showAllBooks();
    }
  }

  toggleUnreadBooks() {
    if (this.allBooksTarget.classList.contains("active")) {
      // => All Books -> Unread Books
      this.allBooksTarget.classList.remove("active");
      this.allBooksTarget.setAttribute("aria-pressed", "false");

      this.unreadBooksTarget.classList.add("active");
      this.unreadBooksTarget.setAttribute("aria-pressed", "true");

      this.showUnreadBooks();
    } else if (this.readBooksTarget.classList.contains("active")) {
      // => Read Books -> Unread Books
      this.readBooksTarget.classList.remove("active");
      this.readBooksTarget.setAttribute("aria-pressed", "false");

      this.unreadBooksTarget.classList.add("active");
      this.unreadBooksTarget.setAttribute("aria-pressed", "true");

      this.showUnreadBooks();
    } else {
      // => Unread Books -> All Books
      this.showAllBooks();
    }
  }

}
