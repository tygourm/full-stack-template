import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import { Outlet, createRootRoute } from "@tanstack/react-router";
import { TanStackRouterDevtools } from "@tanstack/react-router-devtools";

import { Sidebar, SidebarProvider } from "@/components/ui/sidebar";
import { Toaster } from "@/components/ui/sonner";

const Route = createRootRoute({ component: Root });

function Root() {
  return (
    <>
      <SidebarProvider>
        <Sidebar />
        <main className="flex-1">
          <Outlet />
        </main>
      </SidebarProvider>
      <Toaster richColors />
      <ReactQueryDevtools />
      <TanStackRouterDevtools />
    </>
  );
}

export { Route };
