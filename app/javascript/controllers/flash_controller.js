import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  close() {
    this.element.remove();
  }

  connect() {
    this.hideElement();
  }

  hideElement() {
    setTimeout(() => {
      this.element.remove();
    }, 5000);
  }

}
