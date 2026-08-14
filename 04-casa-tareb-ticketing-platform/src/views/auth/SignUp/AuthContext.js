import { useForm } from 'react-hook-form';
import { useNavigate } from 'react-router-dom';
import { useAuthContext } from '@/states';

const useSignUp = () => {
  const { setUser } = useAuthContext();
  const navigate = useNavigate();

  const { control, handleSubmit } = useForm({
    defaultValues: { email: '', password: '', confirmPassword: '' },
  });

  const signup = handleSubmit(async (data) => {
    if (data.password !== data.confirmPassword) {
      alert("Les mots de passe ne correspondent pas !");
      return;
    }

    // Ici tu peux appeler ton API signup si tu veux
    // const res = await HttpClient.post('/signup', data);

    setUser({ email: data.email });
    navigate('/'); // redirection après inscription
  });

  return { control, signup };
};

export default useSignUp;
