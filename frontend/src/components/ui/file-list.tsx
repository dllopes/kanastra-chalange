// src/components/ui/file-list.tsx
import React, { useEffect } from 'react';
import { useUploadContext } from '../../context/UploadContext';

const FileList = () => {
  const { state, dispatch } = useUploadContext();

  useEffect(() => {
    const fetchFiles = async () => {
      try {
        const response = await fetch('http://localhost:3000/files');
        if (response.ok) {
          const data = await response.json();
          dispatch({ type: 'SET_FILES', payload: data });
        } else {
          console.error('Failed to fetch files');
        }
      } catch (error) {
        console.error('An error occurred:', error);
      }
    };

    fetchFiles();
  }, [dispatch]);

  return (
    <div className="file-list">
      <h2>Uploaded Files</h2>
      <ul>
        {Array.isArray(state.files) && state.files.length > 0 ? (
          state.files.map((file: any, index: number) => (
            <li key={index}>
              <p>File: {file.filename} (Uploaded on: {new Date(file.created_at).toLocaleString()})</p>
            </li>
          ))
        ) : (
          <p>No files uploaded yet.</p>
        )}
      </ul>
    </div>
  );
};

export default FileList;
