import { Preloader } from '@/components';
import { Suspense, lazy } from 'react';
const TopNavBar = lazy(() => import('./TopNavBar'));
const AgentNavBar = lazy(() => import('./AgentNavBar'));
const Footer = lazy(() => import('./Footer'));
const AgentLayout = ({
  children
}) => {
  return <>
      <Suspense>
        <TopNavBar />
      </Suspense>

      <main>
        <Suspense>
          <AgentNavBar />
        </Suspense>

        <Suspense fallback={<Preloader />}>{children}</Suspense>
      </main>

      <Suspense>
        <Footer />
      </Suspense>
    </>;
};
export default AgentLayout;