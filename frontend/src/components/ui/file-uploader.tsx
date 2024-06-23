// src/components/ui/file-uploader.tsx
import React, { useState, useRef } from 'react';
import { useUploadContext } from '../../context/UploadContext';

const FileUploader = () => {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [isUploading, setIsUploading] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const { state, dispatch } = useUploadContext();

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files ? e.target.files[0] : null;
    setSelectedFile(file);
  };

  const handleUpload = async () => {
    if (selectedFile) {
      setIsUploading(true);
      dispatch({ type: 'UPLOAD_STARTED' });

      const formData = new FormData();
      formData.append('file', selectedFile);

      try {
        const response = await fetch('http://localhost:3000/files', {
          method: 'POST',
          body: formData,
        });

        if (response.ok) {
          const data = await response.json();
          const uploadedFile = {
            ...data,
            created_at: new Date().toISOString(),
            filename: selectedFile.name,
          };
          dispatch({ type: 'UPLOAD_SUCCESS', payload: uploadedFile });
        } else {
          dispatch({ type: 'UPLOAD_FAILURE', payload: 'File upload failed' });
        }
      } catch (error) {
        dispatch({ type: 'UPLOAD_FAILURE', payload: 'An error occurred during file upload' });
      } finally {
        setIsUploading(false);
        setSelectedFile(null);
        if (fileInputRef.current) {
          fileInputRef.current.value = '';
        }
      }
    }
  };

  return (
    <div className="flex flex-col gap-6">
      <div>
        <label htmlFor="file" className="sr-only">
          Choose a file
        </label>
        <input
          id="file"
          type="file"
          accept=".csv"
          onChange={handleFileChange}
          ref={fileInputRef}
          disabled={isUploading}
        />
      </div>
      {selectedFile && (
        <button
          onClick={handleUpload}
          className="rounded-lg bg-green-800 text-white px-4 py-2 border-none font-semibold"
          disabled={isUploading}
        >
          {isUploading ? 'Uploading...' : 'Upload the file'}
        </button>
      )}
      {state.uploadStatus === 'loading' && <p>Uploading...</p>}
      {state.uploadStatus === 'error' && <p>{state.uploadMessage}</p>}
    </div>
  );
};

export default FileUploader;
