const SCROLL_AT = 95;

const scrollAt = () => {
  const scrollTop =
    document.documentElement.scrollTop || document.body.scrollTop;
  const scrollHeight =
    document.documentElement.scrollHeight || document.body.scrollHeight;
  const clientHeight = document.documentElement.clientHeight;

  return (scrollTop / (scrollHeight - clientHeight)) * 100;
};

const InfiniteScroll = {
  page() {
    return this.el.dataset.page;
  },

  mounted() {
    this.pending = this.page();

    window.addEventListener("scroll", (e) => {
      if (this.pending == this.page() && scrollAt() > SCROLL_AT) {
        this.pending = this.page() + 1;
        this.pushEvent("load_more", {});
      }
    });
  },

  updated() {
    this.pending = this.page();
  },
};

export default InfiniteScroll;
