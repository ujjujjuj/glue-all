const state = { auth: false };

document.querySelector("#reload").addEventListener("click", (e) => {
  window.ipc.invoke("reload");
});

document.querySelector("#toggle").addEventListener("click", (e) => {
  changeTab();
});

const changeTab = () => {
  document.querySelector(".loginwindow").classList.toggle("hidden");
  document.querySelector(".mainwindow").classList.toggle("hidden");
};

document.querySelector("#loginform").addEventListener("submit", (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target));

  // do fetch request
  // on success
  changeTab();
});
