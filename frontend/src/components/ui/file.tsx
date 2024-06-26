import { createContext, ReactNode, useContext, useReducer } from 'react';

// Definição dos tipos
type FileAction =
  | { type: 'UPLOAD_START' }
  | { type: 'UPLOAD_SUCCESS', payload: File }
  | { type: 'UPLOAD_ERROR' };

type FileContextState = {
  file: File | null;
  isLoading: boolean;
};

type FileDispatch = (action: FileAction) => void;

type FileContextType = {
  state: FileContextState;
  dispatch: FileDispatch;
};

type FileProviderProps = {
  children: ReactNode;
};

// Valores iniciais do contexto
export const FileContextInitialValues: FileContextState = {
  file: null,
  isLoading: false,
};

// Criação do contexto
const FileContext = createContext<FileContextType | undefined>(undefined);

// Redutor para gerenciar as ações
const FileReducer = (state: FileContextState, action: FileAction): FileContextState => {
  switch (action.type) {
    case 'UPLOAD_START':
      return { ...state, isLoading: true };
    case 'UPLOAD_SUCCESS':
      return { ...state, isLoading: false, file: action.payload };
    case 'UPLOAD_ERROR':
      return { ...state, isLoading: false };
    default:
      throw new Error(`Unhandled action type`);
  }
};

// Provedor do contexto
export const FileProvider = ({ children }: FileProviderProps) => {
  const [state, dispatch] = useReducer(FileReducer, FileContextInitialValues);

  return (
    <FileContext.Provider value={{ state, dispatch }}>
      {children}
    </FileContext.Provider>
  );
};

// Hook para usar o contexto
export const useFileContext = () => {
  const context = useContext(FileContext);
  if (context === undefined) {
    throw new Error('useFileContext must be used within a FileProvider');
  }
  return context;
};
