# Frontend Application Analysis

## 🏗️ **Application Overview**
This is a **DevOps Pipeline Wizard** built with **Nuxt.js 3** that provides a step-by-step interface for deploying infrastructure and applications using AWS and Terraform. It's a Single Page Application (SPA) with a modern, responsive UI.

## 🛠️ **Technology Stack**
- **Framework**: Nuxt.js 3 (Vue.js 3 based)
- **Styling**: Tailwind CSS 4 + DaisyUI components
- **Icons**: Nuxt Icon module with animated icons
- **Language**: TypeScript
- **Rendering**: Client-side only (SSR disabled)

## 📋 **Application Flow**
The application follows a **4-step wizard pattern**:

### **Step 0: Template Selection**
- Fetches available project templates from the API
- Displays templates in a list format with selection buttons
- Each template has a name and file reference

### **Step 1: Project Profile**
- Collects AWS credentials and project information:
  - Project Name
  - AWS Access Key
  - AWS Secret Key
  - AWS Region (fixed to `ap-southeast-7`)
- Sends project data to API for initial setup

### **Step 2: Configuration**
- Dynamically loads Terraform variables from the selected template
- Parses `.tf` variable files and `.tfvars` files
- Generates form fields based on variable definitions
- Allows users to customize infrastructure parameters
- Saves configuration back to the API

### **Step 3: Launch Review**
- Displays a summary of all selections:
  - Selected template details
  - Project profile information
  - Configuration parameters
- Final confirmation before deployment

### **Step 4: Console/Deployment**
- Shows deployment status with animated rocket icon
- Triggers Terraform deployment via API call
- Includes commented-out kill switch functionality

## 🧩 **Component Breakdown**

### **Core Components**

1. **`app.vue`** - Main application container
   - Manages global state (step, template, profile, configuration)
   - Handles API communication
   - Controls wizard navigation flow

2. **`step.vue`** - Progress indicator
   - Visual timeline showing current step
   - Clickable navigation between completed steps
   - Uses animated icons to show progress

3. **`templatesSelect.vue`** - Template selection
   - Fetches templates from `/api/v1/templates`
   - Displays available project templates
   - Handles template selection

4. **`projectProfile.vue`** - AWS credentials form
   - Collects AWS access credentials
   - Project naming
   - Region selection (locked to ap-southeast-7)

5. **`configuration.vue`** - Dynamic configuration form
   - Parses Terraform variable definitions
   - Generates form fields dynamically
   - Handles `.tfvars` file parsing and generation
   - Converts between Terraform and JSON formats

6. **`launch.vue`** - Deployment summary
   - Shows final review of all selections
   - Confirmation before launching infrastructure

7. **`console.vue`** - Deployment status
   - Animated deployment indicator
   - Real-time status display
   - Emergency kill switch (currently disabled)

8. **`loading.vue`** - Loading indicator
   - Simple animated loading spinner

## 🔧 **Key Features**

### **Dynamic Form Generation**
- Parses Terraform variable files to create forms
- Supports different input types (text, number)
- Automatic field labeling and descriptions

### **State Management**
- Reactive state management using Vue 3 Composition API
- Persistent data flow between wizard steps
- API integration for data persistence

### **API Integration**
- RESTful API communication
- Endpoints for templates, project management, and deployment
- Error handling and loading states

### **Modern UI/UX**
- Responsive design with Tailwind CSS
- DaisyUI components for consistent styling
- Animated icons and transitions
- Step-by-step wizard interface

## 🌐 **API Endpoints Used**
- `GET /api/v1/templates` - Fetch available templates
- `POST /api/v1/projects` - Create new project
- `GET /api/v1/project/{name}/var` - Get Terraform variables
- `GET /api/v1/project/{name}/setting` - Get project settings
- `POST /api/v1/project/{name}/setting` - Update project settings
- `POST /api/v1/project/{name}/launch` - Launch deployment

## 🎯 **User Experience**
The application provides a **guided, wizard-like experience** for users to:
1. Choose from pre-configured infrastructure templates
2. Set up AWS credentials and project details
3. Customize infrastructure parameters through dynamic forms
4. Review and confirm all settings
5. Launch automated infrastructure deployment

This creates a **low-code/no-code experience** for DevOps infrastructure deployment, making complex Terraform configurations accessible through a user-friendly web interface.

## 📁 **File Structure**
```
app/
├── components/           # Vue components
│   ├── configuration.vue # Dynamic Terraform config forms
│   ├── console.vue      # Deployment status display
│   ├── launch.vue       # Final review and launch
│   ├── loading.vue      # Loading indicator
│   ├── projectProfile.vue # AWS credentials form
│   ├── step.vue         # Progress timeline
│   └── templatesSelect.vue # Template selection
├── assets/
│   └── app.css          # Tailwind CSS configuration
├── plugins/
│   └── storage.ts       # Storage plugin (minimal)
├── public/              # Static assets
├── server/              # Server-side code (minimal)
├── app.vue              # Main application component
├── nuxt.config.ts       # Nuxt configuration
├── package.json         # Dependencies
└── tsconfig.json        # TypeScript configuration
```

## 🔧 **Configuration Details**

### **Nuxt Configuration**
- SSR disabled for SPA mode
- Tailwind CSS and DaisyUI integration
- Icon module for animated icons
- API base URL configured for production

### **Dependencies**
- **Core**: Nuxt 3, Vue 3, TypeScript
- **Styling**: Tailwind CSS 4, DaisyUI
- **Icons**: @nuxt/icon with line-md icons
- **HTTP**: Built-in fetch API

## 🚀 **Development & Deployment**
- **Development**: `npm run dev` on port 3000
- **Build**: `npm run build` for production
- **Output**: Static generation with Nitro server
- **Production**: Can be deployed with PM2 or any Node.js hosting
