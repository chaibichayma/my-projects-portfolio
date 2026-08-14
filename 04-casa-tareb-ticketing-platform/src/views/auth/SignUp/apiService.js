import apiClient from './apiClient';
export const saveEventUserService = (data) => {
   apiClient.post('/saveEventUser', data)
   .then((response) => {
        console.log(response.data);
    })
    .catch((error) => {
        console.error(error);
    });
};




