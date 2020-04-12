namespace Bot_Server_WinForms
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.buttonStartServer = new System.Windows.Forms.Button();
            this.listBoxClients = new System.Windows.Forms.ListBox();
            this.buttonStartClients = new System.Windows.Forms.Button();
            this.buttonStopClients = new System.Windows.Forms.Button();
            this.textBoxLog = new System.Windows.Forms.TextBox();
            this.handleClientBindingSource = new System.Windows.Forms.BindingSource(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // buttonStartServer
            // 
            this.buttonStartServer.Location = new System.Drawing.Point(12, 12);
            this.buttonStartServer.Name = "buttonStartServer";
            this.buttonStartServer.Size = new System.Drawing.Size(360, 36);
            this.buttonStartServer.TabIndex = 0;
            this.buttonStartServer.Text = "Start Server";
            this.buttonStartServer.UseVisualStyleBackColor = true;
            this.buttonStartServer.Click += new System.EventHandler(this.buttonStartServer_Click);
            // 
            // listBoxClients
            // 
            this.listBoxClients.FormattingEnabled = true;
            this.listBoxClients.Location = new System.Drawing.Point(11, 420);
            this.listBoxClients.Name = "listBoxClients";
            this.listBoxClients.Size = new System.Drawing.Size(361, 173);
            this.listBoxClients.TabIndex = 1;
            // 
            // buttonStartClients
            // 
            this.buttonStartClients.Location = new System.Drawing.Point(12, 54);
            this.buttonStartClients.Name = "buttonStartClients";
            this.buttonStartClients.Size = new System.Drawing.Size(360, 36);
            this.buttonStartClients.TabIndex = 2;
            this.buttonStartClients.Text = "Start Clients";
            this.buttonStartClients.UseVisualStyleBackColor = true;
            this.buttonStartClients.Click += new System.EventHandler(this.buttonStartClients_Click);
            // 
            // buttonStopClients
            // 
            this.buttonStopClients.Location = new System.Drawing.Point(11, 96);
            this.buttonStopClients.Name = "buttonStopClients";
            this.buttonStopClients.Size = new System.Drawing.Size(360, 36);
            this.buttonStopClients.TabIndex = 3;
            this.buttonStopClients.Text = "Stop Clients";
            this.buttonStopClients.UseVisualStyleBackColor = true;
            this.buttonStopClients.Click += new System.EventHandler(this.buttonStopClients_Click);
            // 
            // textBoxLog
            // 
            this.textBoxLog.Location = new System.Drawing.Point(11, 139);
            this.textBoxLog.Multiline = true;
            this.textBoxLog.Name = "textBoxLog";
            this.textBoxLog.ReadOnly = true;
            this.textBoxLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxLog.Size = new System.Drawing.Size(361, 275);
            this.textBoxLog.TabIndex = 4;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(384, 606);
            this.Controls.Add(this.textBoxLog);
            this.Controls.Add(this.buttonStopClients);
            this.Controls.Add(this.buttonStartClients);
            this.Controls.Add(this.listBoxClients);
            this.Controls.Add(this.buttonStartServer);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonStartServer;
        private System.Windows.Forms.Button buttonStartClients;
        private System.Windows.Forms.Button buttonStopClients;
        public System.Windows.Forms.TextBox textBoxLog;
        public System.Windows.Forms.ListBox listBoxClients;
        private System.Windows.Forms.BindingSource handleClientBindingSource;
    }
}

