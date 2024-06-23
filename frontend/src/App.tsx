// src/App.tsx
import React from 'react';
import { Routes, Route } from 'react-router-dom';
import { Layout, NoMatch, FileUploader, FileList } from './components';
import { UploadProvider } from './context/UploadContext';

const App = () => (
  <UploadProvider>
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={
          <>
            <FileUploader />
            <FileList />
          </>
        } />
        <Route path="*" element={<NoMatch />} />
      </Route>
    </Routes>
  </UploadProvider>
);

export default App;
