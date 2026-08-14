import HttpClient from '@/helpers/httpClient';
import { useAuthContext, useNotificationContext } from '@/states';
import { yupResolver } from '@hookform/resolvers/yup';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { useNavigate, useSearchParams } from 'react-router-dom';
import * as yup from 'yup';
import { URL_API_NAME } from '../../../states/constants';

const useSignIn = () => {
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const {
    saveSession
  } = useAuthContext();
  const [searchParams] = useSearchParams();
  const {
    showNotification
  } = useNotificationContext();
  const loginFormSchema = yup.object({
        email: yup.string().email('Veuillez saisir une adresse e-mail valide').required('Veuillez saisir une adresse e-mail valide'),
        password: yup.string().required('Veuillez entrer votre mot de passe')
        
      });
  const {
    control,
    handleSubmit
  } = useForm({
    resolver: yupResolver(loginFormSchema),
    defaultValues: {
      email: 'user@email.com',
      password: 'password'
    }
  });
  const redirectUser = () => {
    const redirectLink = searchParams.get('redirectTo');
    if (redirectLink) navigate(redirectLink);else navigate('/evenement/grid');

  };
  const login = handleSubmit(async userData => {
    try {
      //const res = await HttpClient.post('/login', values);
      
      
      await fetch(URL_API_NAME+'/events/loginEventUser', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
                 "Access-Control-Allow-Origin": true
              },
              body: '{"email":"'+userData.email+'","password":"'+userData.password+'"}',
              
            }).then((res) => res.json())
          .then((data) => {
            if(data &&  data.isValid){
              if (data.userBean.token) {
              saveSession({
                ...(data.userBean ?? {}),
                token: data.userBean.token
              });
              redirectUser();
              showNotification({
                message: 'Successfully logged in. Redirecting....',
                type: 'success'
              });
            }
            }else{
              showNotification({
                message: data.message,
                type: 'error'
              });
            }
        
          })

      
      


      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (e) {
      if (e.response?.data?.error) {
        showNotification({
          message: `${e.response?.data?.error}`,
          type: 'error'
        });
      }
    } finally {
      setLoading(false);
    }
  });



  return {
    loading,
    login,
    control
  };
};
export default useSignIn;