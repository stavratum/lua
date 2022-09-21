local other = Library.New({ Title = "OTHER" })

other.Button({
    Text = "Destroy BlurEffect",
    Callback = function()
        game:GetService"Lighting":FindFirstChildOfClass"BlurEffect":Destroy()
    end
})
