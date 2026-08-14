import { BackToTop } from '@/components';
import AppRouter from '@/routes/router';
import { AuthProvider, LayoutProvider, NotificationProvider ,PanierProvider} from '@/states';
import configureFakeBackend from './helpers/fake-backend';
import { CookiesProvider } from "react-cookie";
configureFakeBackend();
const App = () => {
  return <CookiesProvider>
      <NotificationProvider>
        <LayoutProvider>
          <AuthProvider>
            <PanierProvider>
            <AppRouter />
            <BackToTop />
            </PanierProvider>
          </AuthProvider>
        </LayoutProvider>
      </NotificationProvider>
    </CookiesProvider>;
};
export default App;