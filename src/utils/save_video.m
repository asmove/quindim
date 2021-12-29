function [] = save_video(fig_handles, video_name, FrameRate)
    % create the video writer with 1 fps
    writerObj = VideoWriter(video_name);
    writerObj.FrameRate = FrameRate;

    % set the seconds per image
    % open the video writer
    open(writerObj);

    % write the frames to the video
    for i=1:length(fig_handles)
        % convert the image to a frame
        frame = fig_handles(i);    
        writeVideo(writerObj, fig_handles(i));
    end

    % close the writer object
    close(writerObj);
end