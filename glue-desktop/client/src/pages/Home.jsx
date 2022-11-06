import { Navigate } from "react-router";
import { useEffect, useState } from "react";
import { useDebounce } from "use-debounce";

const Home = ({ auth, setAuth }) => {
  const [isNotebook, setIsNotebook] = useState(false);
  const [search, setSearch] = useState("");
  const [dSearch] = useDebounce(search, 500);
  const [clients, setClients] = useState([]);
  const [logs, setLogs] = useState([]);

  useEffect(() => {
    if (!dSearch) return;
    (async () => {
      console.log({
        network: await window.ipc.invoke("getToken"),
        keyword: dSearch,
      });
      fetch("http://localhost:5000/api/elastic/history/filter", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          network: await window.ipc.invoke("getToken"),
          keyword: dSearch,
        }),
      })
        .then((res) => res.json())
        .then((data) => {
          console.log(data);
        });
    })();
  }, [dSearch]);

  useEffect(() => {
    (async () => {
      //   fetch("http://localhost:5000/api/elastic/network/nodes", {
      //     method: "POST",
      //     headers: { "content-type": "application/json" },
      //     body: JSON.stringify({
      //       network: await window.ipc.invoke("getToken"),
      //     }),
      //   })
      //     .then((res) => res.json())
      //     .then((data) => console.log(data));
    })();
    window.ipc.on("file", (data) => {
      console.log(data);
      setLogs((_logs) => [
        ...logs,
        { name: data.name, link: data.text, content: "Received text" },
      ]);
    });
  }, []);

  if (!auth) return <Navigate to="/login" />;
  return (
    <div className="flex w-screen h-screen mainwindow">
      <div className="flex flex-col items-center w-56 text-gray-200 bg-gray-800 ht-full">
        <div className="px-12 mt-16 font-mono text-4xl">Glue</div>
        <div className="flex flex-col mt-16 w-full sidebar">
          <div
            className="flex gap-4 items-center px-8 py-4 w-full text-lg opacity-70 transition-opacity cursor-pointer hover:opacity-100 hover:bg-gray-700"
            onClick={() => setIsNotebook(false)}
          >
            <i className="fa-solid fa-house"></i>Home
          </div>
          <div
            className="flex gap-4 items-center px-8 py-4 w-full text-lg opacity-70 transition-opacity cursor-pointer hover:opacity-100 hover:bg-gray-700"
            onClick={() => setIsNotebook(true)}
          >
            <i className="fa-solid fa-file"></i>Notebook
          </div>
          <div className="flex gap-4 items-center px-8 py-4 w-full text-lg opacity-70 transition-opacity cursor-pointer hover:opacity-100 hover:bg-gray-700">
            <i className="fa-solid fa-gear"></i>Settings
          </div>
          <div
            className="flex gap-4 items-center px-8 py-4 mt-40 w-full text-lg opacity-70 transition-opacity cursor-pointer hover:opacity-100 hover:bg-gray-700"
            onClick={() => setAuth(null)}
          >
            <i className="fa-solid fa-right-from-bracket"></i>
            Log Out
          </div>
        </div>
      </div>
      {!isNotebook ? (
        <div className="overflow-y-scroll p-8 w-full text-black">
          <div className="flex flex-col">
            <span className="text-xl">Hello,</span>
            <span className="text-4xl font-bold">{auth.name}</span>
          </div>
          <div className="mt-8">
            <div className="text-2xl font-medium">Connected Devices</div>
            <div className="mt-4">
              <div className="flex gap-8">
                <Device type="Phone" name="Naman's Iphone" />
                {clients.map((client, idx) => (
                  <Device type={client.type} name={client.name} key={idx} />
                ))}
              </div>
            </div>
          </div>
          <div className="my-4 w-full h-px bg-gray-200"></div>
          <div>
            {/* <div className="mb-4 text-2xl font-medium">Recent Actions</div> */}
            <div className="flex flex-col gap-4">
              {logs.map((log, idx) => (
                <Action
                  content="Copied"
                  device="iPhone 11 pro"
                  link="https://discord.com/channels/706096517244518460/711238662293028934"
                  linktext="https://discord.com/channels/706096517244518460/711238662293028934"
                  key={idx}
                />
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className="overflow-y-scroll p-8 w-full text-black">
          <div className="flex flex-col">
            <div className="relative">
              <i class="absolute left-2 top-3 text-gray-400 fa-solid fa-magnifying-glass"></i>
              <input
                type="text"
                placeholder="Search Notebook"
                value={search}
                className="p-2 pl-8 bg-gray-200 rounded"
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </div>
          <div className="flex flex-col gap-4 mt-5">
            <Action
              content="Copied"
              device="iPhone 11 pro"
              link="https://discord.com/channels/706096517244518460/711238662293028934"
              linktext="https://discord.com/channels/706096517244518460/711238662293028934"
            />
            <Action
              content="Created new notebook"
              device="MacBook Pro"
              link="https://google.com"
              linktext="new notebook"
            />
            <Action
              content="Sent file"
              device="iPhone 11 pro"
              link="file://win.pdf"
              linktext="win.pdf"
            />
            <Action
              content="Copied"
              device="iPhone 11 pro"
              link="https://discord.com/channels/706096517244518460/711238662293028934"
              linktext="https://discord.com/channels/706096517244518460/711238662293028934"
            />
            <Action
              content="Copied"
              device="iPhone 11 pro"
              link="https://discord.com/channels/706096517244518460/711238662293028934"
              linktext="https://discord.com/channels/706096517244518460/711238662293028934"
            />
          </div>
        </div>
      )}
    </div>
  );
};

const Device = ({ name, type, id }) => {
  const [hover, setHover] = useState(false);
  return (
    <div>
      <div
        className="flex relative justify-center items-center w-28 h-28 text-5xl text-black bg-gray-200 rounded transition-all cursor-pointer hover:scale-105"
        onMouseEnter={() => setHover(true)}
        onMouseLeave={() => setHover(false)}
        onClick={() => window.ipc.invoke("sendFile", id)}
      >
        <i
          className={`fa-solid opacity-30 ${
            type === "mobile" ? "fa-mobile-screen" : "fa-desktop"
          }`}
        ></i>
        <div
          className={`absolute top-0 right-0 w-6 h-6 bg-gray-700 translate-x-1/2 -translate-y-1/2 rounded text-white text-center text-lg flex justify-center items-center transition-all duration-300 ${
            hover ? "opacity-100" : "opacity-0"
          }`}
        >
          <i className="fa-solid fa-plus"></i>
        </div>
      </div>
      <div className="break-words text-center mt-2 text-gray-800 max-w-[7rem]">
        {name}
      </div>
    </div>
  );
};

const Action = ({ content, device, link, linktext }) => {
  return (
    <div className="flex">
      <div className="flex-1 max-w-[24rem] break-all">
        {content}
        {link ? (
          <>
            &nbsp;
            <a href={link} className="text-blue-500 underline">
              {linktext}
            </a>
          </>
        ) : null}
      </div>
      <div className="ml-auto">{device}</div>
    </div>
  );
};

export default Home;
