import { Controller } from "@hotwired/stimulus"

// ヘッダーのハンバーガーメニューの開け閉め
// 開閉状態は、この要素に付ける is-open クラスで表す（見た目はCSS側で切り替える）
export default class extends Controller {
  static targets = ["button"]

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.element.classList.add("is-open")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    this.buttonTarget.setAttribute("aria-label", "メニューを閉じる")
  }

  close() {
    this.element.classList.remove("is-open")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    this.buttonTarget.setAttribute("aria-label", "メニューを開く")
  }

  get isOpen() {
    return this.element.classList.contains("is-open")
  }
}
