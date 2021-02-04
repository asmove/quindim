function make_video(fname, frames, dt)

    % create the video writer with 1 fps
    writerObj = VideoWriter(fname);
    writerObj.FrameRate = floor(1/dt);

    % open the video writer
    open(writerObj);
    % write the frames to the video
    for i=1:length(frames)
        % convert the image to a frame
        frame = frames(i) ;    
        writeVideo(writerObj, frame);
    end
    % close the writer object
    close(writerObj);

end