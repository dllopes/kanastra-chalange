import React, { createContext, useReducer, useContext, ReactNode } from 'react';

type State = {
  files: any[];
  uploadStatus: string | null;
  uploadMessage: string | null;
};

type Action =
  | { type: 'UPLOAD_STARTED' }
  | { type: 'UPLOAD_SUCCESS'; payload: any }
  | { type: 'UPLOAD_FAILURE'; payload: string }
  | { type: 'SET_FILES'; payload: any[] };

const initialState: State = {
  files: [],
  uploadStatus: null,
  uploadMessage: null,
};

const UploadContext = createContext<{
  state: State;
  dispatch: React.Dispatch<Action>;
}>({ state: initialState, dispatch: () => null });

const uploadReducer = (state: State, action: Action): State => {
  switch (action.type) {
    case 'UPLOAD_STARTED':
      return { ...state, uploadStatus: 'loading', uploadMessage: null };
    case 'UPLOAD_SUCCESS':
      return { ...state, uploadStatus: 'success', uploadMessage: 'File uploaded successfully', files: [action.payload, ...state.files] };
    case 'UPLOAD_FAILURE':
      return { ...state, uploadStatus: 'error', uploadMessage: action.payload };
    case 'SET_FILES':
      return { ...state, files: action.payload };
    default:
      return state;
  }
};

export const UploadProvider = ({ children }: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(uploadReducer, initialState);

  return <UploadContext.Provider value={{ state, dispatch }}>{children}</UploadContext.Provider>;
};

export const useUploadContext = () => useContext(UploadContext);
