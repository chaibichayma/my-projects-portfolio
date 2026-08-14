import { Preloader } from '@/components';
import { Suspense, lazy } from 'react';
const TopNavBar = lazy(() => import('./TopNavBar'));
const FooterWithLinks = lazy(() => import('./FooterWithLinks'));
const HelpLayout = ({
  children
}) => {
  return <>
      <Suspense>
        <TopNavBar />
      </Suspense>

      <Suspense fallback={<Preloader />}>
        <main>{children}</main>
      </Suspense>

      <Suspense>
        <FooterWithLinks />
      </Suspense>
    </>;
};
export default HelpLayout;